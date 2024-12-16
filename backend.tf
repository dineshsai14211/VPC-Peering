terraform {
  backend "gcs" {
    bucket = "vpc-peering-bucket-statefile" # Replace with your GCS bucket name
    prefix = "terraform/state"

  }
}
