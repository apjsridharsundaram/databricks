package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestPipelineModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("pipeline")

	config := common.ModuleTestConfig{
		ModuleName:      "pipeline",
		TestDescription: "Tests Databricks Delta Live Tables pipeline module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"storage": "/mnt/dlt/" + uniqueID,
			"configuration": map[string]string{
				"key": "value",
			},
			"libraries": []map[string]interface{}{
				{
					"notebook": map[string]interface{}{"path": "/Shared/test-notebook"},
					"file":     nil,
					"jar":      nil,
					"whl":      nil,
					"maven":    nil,
				},
			},
			"continuous": false,
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"url",
		},
		SkipDestroy: true, // Pipeline operations can be complex
	}

	common.TestModuleWithConfig(t, config)
}

func TestPipelineModuleContinuous(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("pipeline-cont")

	config := common.ModuleTestConfig{
		ModuleName:      "pipeline",
		TestDescription: "Tests Databricks pipeline in continuous mode",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
		},
		OptionalVars: map[string]interface{}{
			"storage":    "/mnt/dlt/" + uniqueID,
			"continuous": true,
			"libraries": []map[string]interface{}{
				{
					"notebook": map[string]interface{}{"path": "/Shared/test-notebook"},
					"file":     nil,
					"jar":      nil,
					"whl":      nil,
					"maven":    nil,
				},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"name",
			"url",
		},
		SkipDestroy: true,
	}

	common.TestModuleWithConfig(t, config)
}

