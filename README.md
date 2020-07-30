# About

This Terraform module generates a zonefile from the input and stores it in Openstack's object store.

At the current time, only **A** records are supported. More may be added later as the need arises.

The serial number is internally managed. It is generated from the epoch and is only updated if a zonefile change is detected. Assuming your zonefile doesn't change several times per second, this should be good enough for your needs.

# Usage

## Input

- namespace: String to prepend the object name with. Defaults to nothing.
- domain: Domain that the zonefile is for. A dot at the end is not required.
- a_records: List of mappings, each having a **prefix** (subdomain) and **ip** key
- container: Name of the container to create the object under
- cache_ttl: How long (in seconds) should resolvers cache the values retrieved from the zonefile. Defaults to 5 seconds.
- email: Email address to put in **SOA** record. This needs to be a fully qualified domain so the **@** should be replaced by a dot and a dot needs to be appeneded at the end. Defaults to **no-op.domain.** if undefined, where **domain** is the domain you passed as an argument.
- dns_server_name: Fully qualified domain name of the nameserver (with a dot at the end). Defaults to **ns.domain.** if not defined, where **domain** is the domain you passed as an argument. This is used for the SOA record. For standalone internal DNS servers, it can be ignored and left at the default.
- dns_server_ips: If defined, **A** records will be generated mapping the dns server name to those ips.

## Output

The module returns the following output variables:

- name: Name of the generated object in the container
- etag: Etag of the generated object
- content: Content of the generated object (ie, the zonefile)