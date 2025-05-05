terraform {
  required_providers {
    sophosfirewall = {
      source  = "jubinaghara/sophosfirewall"
      version = "1.0.12"
    }
  }
}

provider "sophosfirewall" {
  endpoint = "https://sccfw02.centralindia.cloudapp.azure.com:4444"
  username = "admin"
  password = "Administrat0r@4321"
  insecure = true
}

# Variables for change tracking
variable "change_id" {
  description = "CHG-DEMO-005"
  type        = string
  default     = "CHG-DEMO-001"
}

variable "change_requester" {
  description = "Jubin Aghara"
  type        = string
  default     = "Gartner Demo"
}

variable "change_description" {
  description = "Description of changes being made"
  type        = string
  default     = "Initial network setup for London and US HQ"
}

# Local variables for metadata
locals {
  change_metadata = {
    change_id          = var.change_id
    change_requester   = var.change_requester
    change_description = var.change_description
    change_date        = formatdate("YYYY-MM-DD", timestamp())
  }
  
  # Add metadata to descriptions
  resource_description = "Change: ${var.change_id} - ${var.change_description} - By: ${var.change_requester} on ${formatdate("YYYY-MM-DD", timestamp())}"
}

# IP Host resources
resource "sophosfirewall_iphost" "Gartner_London_BranchNetwork" {
  name        = "Gartner_London_BranchNetwork"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
  description = "London Branch Network - ${local.resource_description}"
}

resource "sophosfirewall_iphost" "Gartner_US_HO_Network" {
  name        = "Gartner_US_HO_Network"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
  description = "US Headquarters Network - ${local.resource_description}"
}



resource "sophosfirewall_iphost" "Gartner_US_HO_Network3" {
  name        = "Gartner_US_HO_Network3"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
  description = "US Headquarters Network - ${local.resource_description}"
}

resource "sophosfirewall_iphost" "Gartner_US_HO_Network4" {
  name        = "Gartner_US_HO_Network4"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
  description = "US Headquarters Network - ${local.resource_description}"
}


# Example firewall rule between networks
resource "sophosfirewall_firewallrule" "london_to_us_rule" {
  name        = "LondonToUS_Access"
  source      = sophosfirewall_iphost.Gartner_London_BranchNetwork.name
  destination = sophosfirewall_iphost.Gartner_US_HO_Network.name
  action      = "accept"
  log         = true
  description = "Allow London to US HQ - ${local.resource_description}"
}

# Generate change documentation file
resource "local_file" "change_documentation" {
  content = <<-EOT
# Sophos Firewall Change Documentation
## Change Details
- **Change ID:** ${var.change_id}
- **Requested By:** ${var.change_requester}
- **Description:** ${var.change_description}
- **Date:** ${formatdate("YYYY-MM-DD", timestamp())}

## Resources Modified
### Networks
- **London Branch:** ${sophosfirewall_iphost.Gartner_London_BranchNetwork.name} (${sophosfirewall_iphost.Gartner_London_BranchNetwork.ip_address}/${sophosfirewall_iphost.Gartner_London_BranchNetwork.subnet})
- **US HQ:** ${sophosfirewall_iphost.Gartner_US_HO_Network.name} (${sophosfirewall_iphost.Gartner_US_HO_Network.ip_address}/${sophosfirewall_iphost.Gartner_US_HO_Network.subnet})

### Firewall Rules
- **London to US Rule:** ${sophosfirewall_firewallrule.london_to_us_rule.name}
  - Source: ${sophosfirewall_firewallrule.london_to_us_rule.source}
  - Destination: ${sophosfirewall_firewallrule.london_to_us_rule.destination}
  - Action: ${sophosfirewall_firewallrule.london_to_us_rule.action}
  - Logging: ${sophosfirewall_firewallrule.london_to_us_rule.log ? "Enabled" : "Disabled"}

## Approval
[ ] Approved by: _______________
[ ] Implemented by: _______________
[ ] Verified by: _______________

EOT

  filename = "change_logs/${var.change_id}.md"
}

# Generate a JSON output for programmatic access
resource "local_file" "change_json" {
  content = jsonencode({
    change_id          = var.change_id
    change_requester   = var.change_requester
    change_description = var.change_description
    change_date        = formatdate("YYYY-MM-DD", timestamp())
    resources = {
      networks = [
        {
          name       = sophosfirewall_iphost.Gartner_London_BranchNetwork.name
          ip_address = sophosfirewall_iphost.Gartner_London_BranchNetwork.ip_address
          subnet     = sophosfirewall_iphost.Gartner_London_BranchNetwork.subnet
        },
        {
          name       = sophosfirewall_iphost.Gartner_US_HO_Network.name
          ip_address = sophosfirewall_iphost.Gartner_US_HO_Network.ip_address
          subnet     = sophosfirewall_iphost.Gartner_US_HO_Network.subnet
        }
      ],
      firewall_rules = [
        {
          name        = sophosfirewall_firewallrule.london_to_us_rule.name
          source      = sophosfirewall_firewallrule.london_to_us_rule.source
          destination = sophosfirewall_firewallrule.london_to_us_rule.destination
          action      = sophosfirewall_firewallrule.london_to_us_rule.action
        }
      ]
    }
  })
  filename = "change_logs/${var.change_id}.json"
}

# Output the change information
output "change_info" {
  value = local.change_metadata
}

output "resources_changed" {
  value = {
    networks = [
      "${sophosfirewall_iphost.Gartner_London_BranchNetwork.name} (${sophosfirewall_iphost.Gartner_London_BranchNetwork.ip_address}/${sophosfirewall_iphost.Gartner_London_BranchNetwork.subnet})",
      "${sophosfirewall_iphost.Gartner_US_HO_Network.name} (${sophosfirewall_iphost.Gartner_US_HO_Network.ip_address}/${sophosfirewall_iphost.Gartner_US_HO_Network.subnet})"
    ],
    firewall_rules = [
      "${sophosfirewall_firewallrule.london_to_us_rule.name}: ${sophosfirewall_firewallrule.london_to_us_rule.source} to ${sophosfirewall_firewallrule.london_to_us_rule.destination}"
    ]
  }
}