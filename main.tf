locals {
  dns_server_name = lookup(
    var.soa_record, 
    "dns_server_name",
    "ns.${var.domain}."
  )
  email = lookup(var.soa_record, "email", "no-op.${var.domain}.")
  dns_server_ips = lookup(var.soa_record, "dns_server_ips", [])
}

locals {
  zonefile_md5 = md5(
      templatefile(
        "${path.module}/zonefile.tpl",
        {
          domain = var.domain
          serial_number = "temp"
          cache_ttl = var.cache_ttl
          a_records = var.a_records
          dns_server_name = local.dns_server_name
          email = local.email
          dns_server_ips = local.dns_server_ips
        }
      )
  )
}

resource "time_static" "zonefile_update" {
  triggers = {
    zonefile_md5 = local.zonefile_md5
  }
}

resource "openstack_objectstorage_object_v1" "zonefile" {
  container_name = var.container
  name           = var.namespace == "" ? var.domain : "${var.domain}-${var.namespace}"
  content_type   = "text/plain"
  content        = templatefile(
    "${path.module}/zonefile.tpl",
    {
      domain = var.domain
      serial_number = time_static.zonefile_update.unix
      cache_ttl = var.cache_ttl
      a_records = var.a_records
      soa_record = var.soa_record
      dns_server_name = local.dns_server_name
      email = local.email
      dns_server_ips = local.dns_server_ips
    }
  )
}