package test

import (
	"fmt"
	"testing"
	"time"

	common "github.com/cititerraform/common"
)

func TestServicePrincipalModule(t *testing.T) {
	// Generate a valid UUID for application_id
	uniqueUUID := "12345678-1234-1234-1234-" + fmt.Sprintf("%012d", time.Now().Unix()%1000000000000)

	config := common.ModuleTestConfig{
		ModuleName:      "service-principal",
		TestDescription: "Tests Databricks service principal module",
		RequiredVars: map[string]interface{}{
			"application_id": uniqueUUID,
		},
		OptionalVars: map[string]interface{}{
			"display_name":                   "Test Service Principal",
			"allow_cluster_create":           false,
			"allow_instance_pool_create":     false,
			"databricks_sql_access":          false,
			"workspace_access":               true,
			"force": true,
		},
		ExpectedOutputs: []string{
			"id",
			"application_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestServicePrincipalModuleWithPermissions(t *testing.T) {
	// Generate a valid UUID for application_id
	uniqueUUID := "87654321-4321-4321-4321-" + fmt.Sprintf("%012d", time.Now().Unix()%1000000000000)

	config := common.ModuleTestConfig{
		ModuleName:      "service-principal",
		TestDescription: "Tests Databricks service principal with full permissions",
		RequiredVars: map[string]interface{}{
			"application_id": uniqueUUID,
		},
		OptionalVars: map[string]interface{}{
			"display_name":                   "Test SP with Permissions",
			"allow_cluster_create":           true,
			"allow_instance_pool_create":     true,
			"databricks_sql_access":          true,
			"workspace_access":               true,
			"active": true,
			"force":  true,
		},
		ExpectedOutputs: []string{
			"id",
			"application_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

