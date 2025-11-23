# Module PowerDNS Record

Module Terraform pour créer automatiquement des enregistrements DNS dans PowerDNS.

## Utilisation

### Enregistrement A simple

```hcl
module "dns_a" {
  source = "../../modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "svc-postgres-1.farmconnect.local"
  type    = "A"
  content = "10.10.20.122"
  ttl     = 300
}
```

### Enregistrement A avec PTR (reverse DNS)

```hcl
module "dns_with_ptr" {
  source = "../../modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "svc-postgres-1.farmconnect.local"
  type    = "A"
  content = "10.10.20.122"
  ttl     = 300

  create_ptr   = true
  reverse_zone = "20.10.10.in-addr.arpa"
}
```

### Enregistrement CNAME

```hcl
module "dns_cname" {
  source = "../../modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "www.farmconnect.local"
  type    = "CNAME"
  content = "svc-traefik-1.farmconnect.local"
  ttl     = 300
}
```

## Variables principales

| Variable | Type | Description | Défaut |
|----------|------|-------------|--------|
| `zone` | string | Zone DNS (ex: `farmconnect.local`) | Requis |
| `name` | string | Nom complet FQDN (ex: `host.farmconnect.local`) | Requis |
| `type` | string | Type d'enregistrement (`A`, `CNAME`, `PTR`) | `A` |
| `content` | string | Contenu (IP pour A, hostname pour CNAME) | Requis |
| `ttl` | number | TTL en secondes | `300` |
| `create_ptr` | bool | Créer un enregistrement PTR automatique | `false` |
| `reverse_zone` | string | Zone inverse pour PTR (ex: `20.10.10.in-addr.arpa`) | `""` |

## Outputs

- `record_id` : ID de l'enregistrement DNS
- `fqdn` : Nom FQDN normalisé
- `ip_address` : Adresse IP (pour les enregistrements A)
- `ptr_record_id` : ID du PTR si créé
- `record_summary` : Résumé de la configuration

## Notes

- Le point final (`.`) est optionnel et sera ajouté automatiquement
- Les deux formats sont valides : `farmconnect.local` ou `farmconnect.local.`
- Le module ne crée **pas** les zones DNS (elles doivent exister)
- Pour les PTR, la zone inverse doit exister dans PowerDNS

## Provider requis

```hcl
terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "~> 1.5.0"
    }
  }
}
```
