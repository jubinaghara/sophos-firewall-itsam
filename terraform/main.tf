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


# IP Host resources
resource "sophosfirewall_iphost" "Gartner_London_BranchNetwork" {
  name        = "Gartner_London_BranchNetwork"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
}

resource "sophosfirewall_iphost" "Gartner_US_HO_Network" {
  name        = "Gartner_US_HO_Network"
  ip_family   = "IPv4"
  host_type   = "Network"
  ip_address  = "192.168.2.0"
  subnet      = "255.255.255.0"
  host_groups = []
}



