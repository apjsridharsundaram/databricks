package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSQLQueryModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-query")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-query",
		TestDescription: "Tests Databricks SQL query module",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"query":          "SELECT 1",
			"data_source_id": "test-warehouse-id",
		},
		OptionalVars: map[string]interface{}{
			"description": "Test SQL query created by terratest",
			"tags": map[string]string{
				"environment": "test",
				"purpose":     "terratest",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
		SkipDestroy: true, // Requires existing warehouse
	}

	common.TestModuleWithConfig(t, config)
}

func TestSQLQueryModuleWithParameters(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-query-params")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-query",
		TestDescription: "Tests Databricks SQL query with parameters",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"query":          "SELECT * FROM table WHERE date = {{date_param}}",
			"data_source_id": "test-warehouse-id",
		},
		OptionalVars: map[string]interface{}{
			"description": "SQL query with parameters",
			"tags": map[string]string{
				"environment": "test",
			},
			"parameters": []map[string]interface{}{
				{
					"name":          "date_param",
					"title":         "Date Parameter",
					"text":          nil,
					"number":        nil,
					"enum":          nil,
					"query_param":   nil,
					"date":          map[string]interface{}{"value": "2024-01-01"},
					"datetime":      nil,
					"datetimerange": nil,
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

