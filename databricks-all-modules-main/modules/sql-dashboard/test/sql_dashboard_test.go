package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSQLDashboardModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-dashboard")
	warehouseID := common.GetEnvOrDefault("TEST_SQL_WAREHOUSE_ID", "test-warehouse-id")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-dashboard",
		TestDescription: "Tests Databricks SQL dashboard module",
		RequiredVars: map[string]interface{}{
			"name":          uniqueID,
			"warehouse_id": warehouseID,
		},
		OptionalVars: map[string]interface{}{
			"tags": map[string]string{
				"environment": "test",
				"purpose":     "terratest",
			},
		},
		ExpectedOutputs: []string{
			"id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestSQLDashboardModuleWithParent(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-dashboard-parent")
	warehouseID := common.GetEnvOrDefault("TEST_SQL_WAREHOUSE_ID", "test-warehouse-id")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-dashboard",
		TestDescription: "Tests Databricks SQL dashboard with parent folder",
		RequiredVars: map[string]interface{}{
			"name":          uniqueID,
			"warehouse_id": warehouseID,
		},
		OptionalVars: map[string]interface{}{
			"parent": "folders/test-folder",
			"tags": map[string]string{
				"environment": "test",
			},
		},
		ExpectedOutputs: []string{
			"id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

