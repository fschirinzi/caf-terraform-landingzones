# settings for the transit network blueprint 

#resource group creation
resource_groups_shared_transit = {
    HUB-NET-TRANSIT    = {
        name = "-hub-network-transit"  
        location = "southeastasia"  
    }
}

# Settings for the shared services egress vnet
networking_transit = {
        vnet = {
            name                = "_Shared_Transit"
            address_space       = ["172.16.0.0/23"]   
            dns                 = ["192.168.0.16", "192.168.0.64"]
        }
        specialsubnets     = {
            GatewaySubnet           = {
                name                = "GatewaySubnet" #Must be called GateWaySubnet in order to host a Virtual Network Gateway
                cidr                = "172.16.0.0/24"
                service_endpoints   = []
                nsg_inbound         = []
                nsg_outbound        = []
            }
          }
        subnets = {
            subnet1                 = {
                name                = "NetworkMonitoring"
                cidr                =  "172.16.1.0/24"
                service_endpoints   = []
                nsg_inbound         = []
                nsg_outbound        = []
            }
             }
}

# Settings for the public IP address to be used for egress
# ip_address_deploy            = true
ip_address_name              = "arnaud-pip-vpn"

public_ip_addr = {
    allocation_method = "Dynamic"
    sku               = "Basic"
    #For basic SKU, you can pick the zone to be deployed - if you want multi zone - pick Standard IP and pick AZ aware VPN gateway SKU
    #dns_prefix        = "arnaudvpn"
    #zones             = ["1"]
}

ip_diags = {
    log = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                ["DDoSProtectionNotifications", true, true, 30],
                ["DDoSMitigationFlowLogs", true, true, 30],
                ["DDoSMitigationReports", true, true, 30],
        ]
    metric = [
               ["AllMetrics", true, true, 30],
    ]
}

# Settings for the Virtual Network gateway to be created
gateway_config  = {
    gateway_type                 = "VPN" 
    # Possible values are "VPN" or "ExpressRoute"
    vpn_gateway_name             = "magateway"
    active_active                = false
    #An active-active gateway requires a HighPerformance or an UltraPerformance sku. If false, an active-standby gateway will be created. Defaults to false.
    enable_bgp                   = false 
    #If true, BGP (Border Gateway Protocol) will be enabled for this Virtual Network Gateway. Defaults to false.
    vpn_gateway_sku              = "Basic"
    #Valid options are Basic, Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, and VpnGw3AZ 
    #and depend on the gateway_type (ER or VPN) and vpn_type arguments, ie: PolicyBased gateway only supports the Basic sku.
    vpn_gateway_type             = "RouteBased"
    #The routing type of the Virtual Network Gateway. Valid options are RouteBased or PolicyBased. Defaults to RouteBased.
}

gateway_diags = {
    log = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                ["GatewayDiagnosticLog", true, true, 30],
                ["TunnelDiagnosticLog", true, true, 30],
                ["RouteDiagnosticLog", true, true, 30],
                ["IKEDiagnosticLog", true, true, 30],
                ["P2SDiagnosticLog", true, true, 30],
        ]
    metric = [
               ["AllMetrics", true, true, 30],
    ]
}

#Settings for the connection to be established
#Settings for the local network connection 
connection_name = "onpremconnection"
remote_network_connect = true

remote_network = {
    gateway_name = "arnaudlocalnetwork"
    gateway_ip = "1.2.3.4"
    gateway_adress_space = ["1.0.0.0/8"]
}