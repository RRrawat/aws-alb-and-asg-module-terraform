variable "enviroment" {
    type = string
	description	= "Provide environment (DEV/TEST/PRD)"
}


variable "additional_tags"{
	type = map(string)
	default = null
	description = "If user wants to add any other additional tags to resource"
}
