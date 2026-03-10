package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestUserModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("user")

	config := common.ModuleTestConfig{
		ModuleName:      "user",
		TestDescription: "Tests Databricks user module",
		RequiredVars: map[string]interface{}{
			"user_name": uniqueID + "@example.com",
		},
		OptionalVars: map[string]interface{}{
			"display_name":                   "Test User",
			"allow_cluster_create":           false,
			"allow_instance_pool_create":     false,
			"databricks_sql_access":          false,
			"workspace_access":               true,
			"force": true,
		},
		ExpectedOutputs: []string{
			"id",
			"user_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestUserModuleWithPermissions(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("user-perms")

	config := common.ModuleTestConfig{
		ModuleName:      "user",
		TestDescription: "Tests Databricks user module with full permissions",
		RequiredVars: map[string]interface{}{
			"user_name": uniqueID + "@example.com",
		},
		OptionalVars: map[string]interface{}{
			"display_name":                   "Test User with Permissions",
			"allow_cluster_create":           true,
			"allow_instance_pool_create":     true,
			"databricks_sql_access":          true,
			"workspace_access":               true,
			"force": true,
		},
		ExpectedOutputs: []string{
			"id",
			"user_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

