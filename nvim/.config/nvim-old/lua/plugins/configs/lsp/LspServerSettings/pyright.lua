return {
	python = {
		analysis = {
			typeCheckingMode = "off", -- "off", "basic" and "strict"
			diagnosticMode = "workspace",
			inlayHints = {
				variableTypes = true,
				functionReturnTypes = true,
			},
		},
	},
}
