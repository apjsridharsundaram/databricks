package test

import (
	"fmt"
	"testing"

	common "github.com/cititerraform/common"
)

func TestTableModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	catalogName := defaults.CatalogName

	uniqueID := common.GenerateUniqueTestID("table")

	config := common.ModuleTestConfig{
		ModuleName:      "table",
		TestDescription: "Tests Databricks Unity Catalog table module",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"catalog_name": catalogName,
			"schema_name":  "default",
			"table_type":   "MANAGED",
			"data_source_format": "DELTA",
			"columns": []map[string]interface{}{
				{
					"name":     "id",
					"type":     "INT",
					"nullable": false,
					"comment":  "Primary key",
				},
				{
					"name":     "name",
					"type":     "STRING",
					"nullable": true,
					"comment":  "Name field",
				},
			},
		},
		OptionalVars: map[string]interface{}{
			"comment": "Test table created by terratest",
			"properties": map[string]string{
				"environment": "test",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"full_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestTableModuleExternal(t *testing.T) {
	defaults := common.GetTestDefaults()
	catalogName := defaults.CatalogName
	bucketName := defaults.S3BucketName

	uniqueID := common.GenerateUniqueTestID("table-ext")

	storageLoc := fmt.Sprintf("s3://%s/path/", bucketName)

	config := common.ModuleTestConfig{
		ModuleName:      "table",
		TestDescription: "Tests Databricks table module with external table type",
		RequiredVars: map[string]interface{}{
			"name":               uniqueID,
			"catalog_name":       catalogName,
			"schema_name":        "default",
			"table_type":         "EXTERNAL",
			"data_source_format": "DELTA",
			"storage_location":   storageLoc,
			"columns": []map[string]interface{}{
				{
					"name": "col1",
					"type": "STRING",
				},
			},
		},
		OptionalVars: map[string]interface{}{},
		ExpectedOutputs: []string{
			"id",
			"name",
			"full_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

