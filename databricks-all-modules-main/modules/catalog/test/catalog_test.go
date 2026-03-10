package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestCatalogModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("catalog")

	config := common.ModuleTestConfig{
		ModuleName:      "catalog",
		TestDescription: "Tests Databricks Unity Catalog module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"comment": "Test catalog created by terratest",
			"properties": map[string]string{
				"environment": "test",
				"purpose":     "terratest",
			},
			"isolation_mode": "ISOLATED",
			"force_destroy":  true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"metastore_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestCatalogModuleWithMinimalConfig(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("catalog-min")

	config := common.ModuleTestConfig{
		ModuleName:      "catalog",
		TestDescription: "Tests Databricks catalog module with minimal configuration",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestCatalogModuleWithOwner(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("catalog-owner")

	config := common.ModuleTestConfig{
		ModuleName:      "catalog",
		TestDescription: "Tests Databricks catalog module with owner configuration",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"comment":       "Catalog with owner for production",
			"owner":         "account users", // Default group that should exist
			"force_destroy": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"metastore_id",
		},
	}

	common.TestModuleWithConfig(t, config)
}

