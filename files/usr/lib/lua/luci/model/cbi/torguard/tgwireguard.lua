-- Import the necessary LuCI modules
local uci = require("luci.model.uci").cursor()
local sys = require("luci.sys")
local util = require("luci.util")

-- Function to check if WireGuard (wg) is active
local function is_vpn_connected()
    local status = sys.call("ip link show wg >/dev/null 2>&1")
    return (status == 0) and "Connected" or "Disconnected"
end

-- Function to get RX and TX statistics for wg
local function get_vpn_traffic()
    local rx, tx = "N/A", "N/A"
    local f = io.popen("ifconfig wg | grep 'RX bytes' 2>/dev/null")
    if f then
        local output = f:read("*a")
        f:close()
        if output then
            rx = output:match("RX bytes:(%d+)") or "N/A"
            tx = output:match("TX bytes:(%d+)") or "N/A"
        end
    end
    return rx, tx
end

-- Define the model
m = Map("tgwireguard_cfg", "TorGuard WireGuard Setup")

-- VPN Status Section
status_section = m:section(TypedSection, "wgconfig", "WireGuard VPN Status")
status_section.anonymous = true
status_section.addremove = false

status = status_section:option(DummyValue, "_vpn_status", translate("VPN Status"))
status.value = is_vpn_connected()

-- VPN Traffic Stats
rx, tx = get_vpn_traffic()
rx_stat = status_section:option(DummyValue, "_vpn_rx", translate("RX Bytes"))
rx_stat.value = rx .. " Bytes"

tx_stat = status_section:option(DummyValue, "_vpn_tx", translate("TX Bytes"))
tx_stat.value = tx .. " Bytes"

-- Define the section for the WireGuard settings
s = m:section(TypedSection, "wgconfig", "Copy Paste Your TorGuard WireGuard Settings, Click Save & Apply")
s.anonymous = true
s.addremove = false

-- Define the text input field for the WireGuard settings
ta = s:option(TextValue, "wgconfig")
ta.rows = 20
ta.wrap = "off"

-- Define the section for the WireGuard firewall zone
f = m:section(TypedSection, "wgconfig", "WireGuard Firewall Zone: (wan = Remote VPN IP) (lan = Local VPN IP Gateway)")
f.anonymous = true
f.addremove = false

a = f:option(ListValue, "TG_MODE", "Firewall Zone (default = wan)")
a:value("wan", "wan")
a:value("lan", "lan")
a.default = "wan"
a.optional = false
a.rmempty = false

w = m:section(TypedSection, "wgconfig", "WireGuard VPN Control: Start/Stop WireGuard After Saving Settings")

btnStop = w:option(Button, "_btn_start", translate("Click to Stop WireGuard"))
function btnStop.write()
    io.popen("/etc/init.d/tgwireguard stop")
end

btnStart = w:option(Button, "_btn_stop", translate("Click to Start WireGuard"))
function btnStart.write()
    io.popen("/etc/init.d/tgwireguard start")
end


-- Define the function to extract WireGuard configuration values from the user input
function extract_wireguard_config(input)
    if not input then
        return ''
    end
    -- Extract the interface block
    local interface = input:match("%[Interface%](.-)%[Peer%]")
    if interface then
        -- Extract the values for PrivateKey, ListenPort, MTU, and Address
        local privateKey = interface:match("PrivateKey%s*=%s*([%w/+=]+)")
        local listenPort = interface:match("ListenPort%s*=%s*(%d+)")
        local mtu = interface:match("MTU%s*=%s*(%d+)")
        local address = interface:match("Address%s*=%s*(%S+)")
        -- Extract the peer block
        local peer = input:match("%[Peer%](.-)$")
        
        -- Extract the values for PublicKey, AllowedIPs, Endpoint, and PersistentKeepalive
        local publicKey = peer:match("PublicKey%s*=%s*([%w/+=]+)")
        local allowedIPs = peer:match("AllowedIPs%s*=%s*([,%d./]+)")
        local endpoint = peer:match("Endpoint%s*=%s*([%d.:]+)")
        local endpointIP, endpointPort = endpoint:match("([^:]+):?(%d*)")
        endpointIP = endpointIP:gsub("=", "")
        endpointPort = endpointPort:gsub("=", "")
        local persistentKeepalive = peer:match("PersistentKeepalive%s*=%s*(%d+)")
        
        return {
            privatekey = privateKey,
            address = address,
            publickey = publicKey,
            endpointip = endpointIP,
            endpointport = endpointPort,
            allowedips = allowedIPs
        }
    else
        return ''
    end
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
    local text = uci:get("tgwireguard_cfg", "settings", "wgconfig")
    if text then
        local config = extract_wireguard_config(tostring(text))
        if config.privatekey and config.address and config.publickey and config.endpointip and config.endpointport and config.allowedips then
            uci:set("tgwireguard_cfg", "settings", "TGWG_PRIVKEY", config.privatekey)
            uci:set("tgwireguard_cfg", "settings", "TGWG_ADDR", config.address)
            uci:set("tgwireguard_cfg", "settings", "TGWG_PUBKEY", config.publickey)
            uci:set("tgwireguard_cfg", "settings", "TGWG_ENDHOST", config.endpointip)
            uci:set("tgwireguard_cfg", "settings", "TGWG_ENDPORT", config.endpointport)
            uci:set("tgwireguard_cfg", "settings", "TGWG_ALLOWEDIP", config.allowedips)
            uci:commit("tgwireguard_cfg")
       end
    end
end


-- Return the configuration page
return m
