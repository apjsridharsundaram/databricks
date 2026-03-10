package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSecretScopeModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("scope")

	config := common.ModuleTestConfig{
		ModuleName:      "secret-scope",
		TestDescription: "Tests Databricks secret scope module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"initial_manage_principal": "users",
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestSecretScopeModuleBackendTypeDatabricks(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("scope-db")

	config := common.ModuleTestConfig{
		ModuleName:      "secret-scope",
		TestDescription: "Tests Databricks secret scope with Databricks backend",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			// backend_type removed - defaults to DATABRICKS
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

