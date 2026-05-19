locals {
  ingress_rule1 = [ # "ingress_rule1" -> This is variable.
    {
      port        = 22
      description = "port for SSH"
    },
    {
      port        = 80
      description = "port for HTTP"
    },
    {
      port        = 443
      description = "port for HTTPS"
    },
    {
      port        = 8443
      description = "port for secure HTTPS"
    }
  ]

  ingress_rule2 = [ # "ingress_rule2" -> This is variable.
    {
      port        = 22
      description = "port for SSH"
    },
    {
      port        = 8080
      description = "port for Jenins & Tomcat"
    },
    {
      port        = 5600
      description = "port for Custom Java Application"
    }
  ]
}



/*
The point of this 'locals' block is: you are storing reusable port-rule data in one place, So later
Terraform can loop over it and generate security groups rules dunamically.  

Think of it as your menu, not the meal.

*/