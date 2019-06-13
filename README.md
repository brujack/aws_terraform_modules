# terraform_modules

Sadly this code actually is unusable since terraform does not have an easy system for inheriting the values of either variables or outputs from one module to another.

You cannot for example create a vpc in one module and then reference the vpc id in another module to build a security group.

The only way to do it would be to create a nested series of modules, which both defeats the re-usability of modules and makes writing and debugging code too complicated.

goto either https://github.com/brujack/terraform_ansible or https://github.com/brujack/terraform-enterprise_ansible for simple to understand/use/write way of terraform using a form of modules that actually works.
