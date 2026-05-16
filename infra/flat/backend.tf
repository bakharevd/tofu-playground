terraform {
  backend "s3" {
    bucket      = "tofu-playground-state"
    key         = "flat/terraform.tfstate"
    endpoint    = "https://s3.twcstorage.ru"
    region      = "ru-1"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true

    encrypt = true
  }
}