terraform {
    backend "remote" {
    organization = "devfest"
    workspaces {
      name = "terraform-demo"
    }
  }
}

