output "commontags" {
    value = merge({
        Enviroment = var.enviroment
    },
	var.additional_tags,
	)

}
