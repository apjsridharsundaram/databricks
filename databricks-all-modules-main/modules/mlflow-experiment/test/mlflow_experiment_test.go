package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestMLflowExperimentModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("mlflow-exp")

	config := common.ModuleTestConfig{
		ModuleName:      "mlflow-experiment",
		TestDescription: "Tests Databricks MLflow experiment module",
		RequiredVars: map[string]interface{}{
			"name": "/Users/test/" + uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"artifact_location": "dbfs:/mlflow-experiments/" + uniqueID,
			"description":       "Test MLflow experiment created by terratest",
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestMLflowExperimentModuleWithTags(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("mlflow-exp-tags")

	config := common.ModuleTestConfig{
		ModuleName:      "mlflow-experiment",
		TestDescription: "Tests Databricks MLflow experiment with tags",
		RequiredVars: map[string]interface{}{
			"name": "/Users/test/" + uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"description": "MLflow experiment with tags",
		},
		ExpectedOutputs: []string{
			"id",
			"name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

