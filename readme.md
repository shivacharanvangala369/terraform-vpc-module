### Terraform AWS VPC

This module will create following resources

1. VPC
2. IGW with VPC association
3. Subnets --> public private databsse
4. Route tables --> Public Private database
5. Assocataions and Routes 
6. EIP
7. Nat gateway to provide egree internet access to private and database subnets
8. VPC Peering with defult vpc
9. Route table entries through peering

### Inputs
* project -(requried) string type, user must provide project name ex: roboshop, expance.
* Environment -(requried) string type, user must provide env name ex: dev , prod, uat.
* tags ( optinal) list type, user can provide the tags they want to have.
* Cider_blocK (optinal) lsit type,  user can provide the cider 
