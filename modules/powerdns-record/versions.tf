terraform {
  required_version = ">= 1.5.0"

  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "~> 1.5.0"
    }
  }
}
