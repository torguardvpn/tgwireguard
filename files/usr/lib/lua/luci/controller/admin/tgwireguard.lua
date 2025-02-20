module("luci.controller.admin.tgwireguard", package.seeall)
function index()
	entry({"admin", "vpn", "tgwireguard"}, cbi("torguard/tgwireguard"), _("TorGuard Wireguard"), 102)
end