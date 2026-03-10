package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestSQLAlertModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	queryID := defaults.QueryID
	uniqueID := common.GenerateUniqueTestID("sql-alert")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-alert",
		TestDescription: "Tests Databricks SQL alert module",
		RequiredVars: map[string]interface{}{
			"name":            uniqueID,
			"query_id":        queryID,
			"options_column":  "value",
			"options_op":      ">=",
			"options_value":   "100",
		},
		OptionalVars: map[string]interface{}{
			"rearm": 60,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
		SkipDestroy: true, // Requires existing query
	}

	common.TestModuleWithConfig(t, config)
}

func TestSQLAlertModuleWithCustomThreshold(t *testing.T) {
	defaults := common.GetTestDefaults()
	queryID := defaults.QueryID
	uniqueID := common.GenerateUniqueTestID("sql-alert-threshold")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-alert",
		TestDescription: "Tests Databricks SQL alert with custom threshold",
		RequiredVars: map[string]interface{}{
			"name":            uniqueID,
			"query_id":        queryID,
			"options_column":  "count",
			"options_op":      ">",
			"options_value":   "1000",
		},
		OptionalVars: map[string]interface{}{
			"rearm": 300,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

