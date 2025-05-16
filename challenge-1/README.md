# Challenge 1 - Déployer un VPC modulaire avec sous-réseaux publics et privés

## 🎯 Objectifs :
Écrire ton premier module Terraform "réutilisable"

Structurer proprement ton projet (monorepo avec /modules, /environments/dev)

Utiliser terraform plan, apply, output

Déployer un VPC avec :

2 AZs

2 subnets publics

2 subnets privés

Internet Gateway

NAT Gateway

## 💡 Concepts visés :
Modules

Variables typées

for_each, count

Outputs

Provider AWS + régions

# 🧪 TP #1 — VPC modulaire multi-AZ avec subnets publics/privés
## 🎯 Objectif final
Créer un module réutilisable vpc et le consommer dans un environnement dev pour créer une architecture réseau AWS avec :

Un VPC

2 subnets publics (dans 2 AZs différentes)

2 subnets privés (dans les mêmes AZs)

Une Internet Gateway

Une NAT Gateway (1 seule, dans la première AZ)

Des route tables configurées pour chaque type de subnet

## 📁 Structure attendue du projet
terraform-vpc/
├── modules/
│   └── vpc/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
├── environments/
│   └── dev/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── backend.tf (optionnel)

## 📌 Étapes
### ✅ Étape 1 – Initialisation du projet
Crée le dossier terraform-vpc/

Crée la structure ci-dessus

Initialise ton provider AWS dans environments/dev/main.tf

hcl
Copier
Modifier

provider "aws" {
  region = var.aws_region
}

### ✅ Étape 2 – Crée le module VPC
Dans modules/vpc/ :

main.tf :

Ressources : aws_vpc, aws_subnet, aws_internet_gateway, aws_nat_gateway, aws_eip, aws_route_table, aws_route_table_association

variables.tf :

vpc_cidr, public_subnets, private_subnets, azs, etc.

outputs.tf :

VPC ID, subnet IDs, route table IDs, etc.

➡️ Tu devras utiliser for_each pour créer dynamiquement les subnets publics et privés.

### ✅ Étape 3 – Utilisation du module
Dans environments/dev/main.tf :

module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr       = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  azs            = ["eu-west-1a", "eu-west-1b"]
  enable_nat     = true
}

### ✅ Étape 4 – Variables & tfvars
Crée variables.tf dans environments/dev pour définir aws_region, etc.
Ajoute un fichier terraform.tfvars pour injecter les valeurs (facultatif mais recommandé).

### ✅ Étape 5 – Tests
terraform init

terraform validate

terraform plan

terraform apply

### 🧠 Concepts techniques à mettre en œuvre
for_each ou count pour les subnets

Dépendances implicites/explicites (depends_on)

output de modules et accès via module.vpc.*

Manipulation de listes et maps (element, index, lookup, etc.)

Séparation logique clean entre module et env

### ✅ Bonus
Utilise terraform-docs pour générer la doc du module.

Ajoute une configuration de backend S3 dans backend.tf (optionnel)

Teste le même module avec d’autres variables dans un env staging/

