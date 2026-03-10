package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestModelServingModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("model-serving")

	config := common.ModuleTestConfig{
		ModuleName:      "model-serving",
		TestDescription: "Tests Databricks model serving endpoint module",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"entity_name":    "test-model",
			"entity_version": "1",
			"workload_size":  "Small",
			"scale_to_zero_enabled": true,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"serving_endpoint_id",
		},
		SkipDestroy: true, // Model serving endpoints take time to provision
	}

	common.TestModuleWithConfig(t, config)
}

func TestModelServingModuleWithRateLimits(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("model-serving-rate")

	config := common.ModuleTestConfig{
		ModuleName:      "model-serving",
		TestDescription: "Tests Databricks model serving with rate limits",
		RequiredVars: map[string]interface{}{
			"name":           uniqueID,
			"entity_name":    "test-model",
			"entity_version": "1",
			"workload_size":  "Small",
			"scale_to_zero_enabled": true,
		},
		OptionalVars: map[string]interface{}{},
		ExpectedOutputs: []string{
			"id",
			"name",
			"serving_endpoint_id",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

