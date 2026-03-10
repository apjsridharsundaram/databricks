package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSchemaModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	catalogName := defaults.CatalogName

	uniqueID := common.GenerateUniqueTestID("schema")

	config := common.ModuleTestConfig{
		ModuleName:      "schema",
		TestDescription: "Tests Databricks Unity Catalog schema module",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"catalog_name": catalogName,
		},
		OptionalVars: map[string]interface{}{
			"comment": "Test schema created by terratest",
			"properties": map[string]string{
				"environment": "test",
			},
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"full_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestSchemaModuleWithStorageRoot(t *testing.T) {
	defaults := common.GetTestDefaults()
	catalogName := defaults.CatalogName

	uniqueID := common.GenerateUniqueTestID("schema-storage")

	config := common.ModuleTestConfig{
		ModuleName:      "schema",
		TestDescription: "Tests Databricks schema module with storage root",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"catalog_name": catalogName,
		},
		OptionalVars: map[string]interface{}{
			"comment":       "Schema with custom storage root",
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"full_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

