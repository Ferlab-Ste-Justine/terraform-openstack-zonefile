variable namespace {
  description = "Namespace to prepend to resource names"
  type = string
  default = ""
}

variable domain {
  description = "Name of the domain for the zonefile"
  type = string
}

variable a_records {
  description = "List of a records having the following keys: prefix, ip"
  type = list(map(string))
}

variable container {
  description = "Name of the container that will container the zonefile object"
  type = string
}

variable cache_ttl {
  description = "How long should replies be cached in seconds."
  type = number
  default = 5
}

variable soa_record {
  description = "Information for the soa record. Should contain the following keys: email, dns_server_name, dns_server_ips"
  type = map(any)
  default = {}
}