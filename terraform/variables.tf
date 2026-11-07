variable "environment" {
  type        = string
  description = "Target environment (dev, staging, prod)"
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "eastus"
}

variable "resource_groups" {
  type = map(object({
    location = string
    tags     = map(string)
  }))
  description = "Resource groups to create using for_each"
  default = {
    "network" = {
      location = "eastus"
      tags = {
        Workload    = "Hub-Network"
        ManagedBy   = "Terraform"
        Compliance  = "CIS-Azure"
      }
    },
    "security" = {
      location = "eastus"
      tags = {
        Workload    = "KeyVault-Security"
        ManagedBy   = "Terraform"
        Compliance  = "CIS-Azure"
      }
    }
  }
}

variable "subnets" {
  type = map(object({
    cidr_block           = string
    service_endpoints    = list(string)
    enforce_private_link = bool
  }))
  description = "Subnets configuration managed with for_each"
  default = {
    "snet-gateway" = {
      cidr_block           = "10.0.1.0/24"
      service_endpoints    = []
      enforce_private_link = false
    },
    "snet-workload" = {
      cidr_block           = "10.0.2.0/24"
      service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
      enforce_private_link = true
    }
  }
}
