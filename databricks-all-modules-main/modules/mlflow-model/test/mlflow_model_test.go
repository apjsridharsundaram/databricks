package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMLflowModelModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("mlflow-model")

	config := common.ModuleTestConfig{
		ModuleName:      "mlflow-model",
		TestDescription: "Tests Databricks MLflow model module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"description": "Test MLflow model created by terratest",
			"tags": []map[string]interface{}{
				{
					"key":   "environment",
					"value": "test",
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestMLflowModelModuleWithMultipleTags(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("mlflow-model-tags")

	config := common.ModuleTestConfig{
		ModuleName:      "mlflow-model",
		TestDescription: "Tests Databricks MLflow model with multiple tags",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"description": "MLflow model with multiple tags",
			"tags": []map[string]interface{}{
				{
					"key":   "environment",
					"value": "test",
				},
				{
					"key":   "version",
					"value": "1.0",
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

