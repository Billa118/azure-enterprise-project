variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 3
    error_message = "Resource Group name must be at least 4 characters long."
  }
}

variable "location" {
  description = "Azure Region"
  type        = string

  validation {
    condition = contains([
      "Central India",
      "East US",
      "East US 2"
    ], var.location)

    error_message = "Location must be Central India, East US, or East US 2."
  }
}
