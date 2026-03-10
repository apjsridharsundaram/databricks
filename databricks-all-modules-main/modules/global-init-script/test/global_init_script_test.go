package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestGlobalInitScriptModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("init-script")

	scriptContent := `#!/bin/bash
echo "Global init script for testing"
# Add any initialization logic here
`

	config := common.ModuleTestConfig{
		ModuleName:      "global-init-script",
		TestDescription: "Tests Databricks global init script module",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"content_base64": scriptContent,  // Will be handled properly
		},
		OptionalVars: map[string]interface{}{
			"enabled":  true,
			"position": 10,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestGlobalInitScriptModuleDisabled(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("init-script-disabled")

	scriptContent := `#!/bin/bash
echo "Disabled init script"
`

	config := common.ModuleTestConfig{
		ModuleName:      "global-init-script",
		TestDescription: "Tests Databricks global init script in disabled state",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"content_base64": scriptContent,
		},
		OptionalVars: map[string]interface{}{
			"enabled": false,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

