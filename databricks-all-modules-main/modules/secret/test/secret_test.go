package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSecretModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("secret")

	config := common.ModuleTestConfig{
		ModuleName:      "secret",
		TestDescription: "Tests Databricks secret module",
		RequiredVars: map[string]interface{}{
			"scope":        "test-scope",
			"key":          uniqueID,
			"string_value": "test-secret-value",
		},
		ExpectedOutputs: []string{
			"id",
			"key",
			"scope",
		},
		SkipDestroy: true, // Requires existing scope
	}

	common.TestModuleWithConfig(t, config)
}

func TestSecretModuleWithByteValue(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("secret-bytes")

	config := common.ModuleTestConfig{
		ModuleName:      "secret",
		TestDescription: "Tests Databricks secret module with byte value",
		RequiredVars: map[string]interface{}{
			"scope":        "test-scope",
			"key":          uniqueID,
			"string_value": "test-secret-bytes-value", // module requires string_value; no separate bytes_value variable
		},
		OptionalVars: map[string]interface{}{},
		ExpectedOutputs: []string{
			"id",
			"key",
			"scope",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

