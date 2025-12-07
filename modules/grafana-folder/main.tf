resource "grafana_folder" "this" {
  title                        = var.title
  uid                          = var.uid
  org_id                       = var.org_id
  parent_folder_uid            = var.parent_folder_uid
  prevent_destroy_if_not_empty = var.prevent_destroy_if_not_empty
}
