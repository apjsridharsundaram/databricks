package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestTokenModule(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "token",
		TestDescription: "Tests Databricks token module",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"comment":           "Test token created by terratest",
			"lifetime_seconds":  3600,
		},
		ExpectedOutputs: []string{
			"id",
			"token_value",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestTokenModuleWithNoExpiry(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "token",
		TestDescription: "Tests Databricks token module with no expiry",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"comment": "Token with no expiration",
		},
		ExpectedOutputs: []string{
			"id",
			"token_value",
		},
	}

	common.TestModuleWithConfig(t, config)
}

