package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestNotebookModule(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("notebook")

	notebookContent := `# Databricks notebook source
print("Hello from terratest!")
`

	config := common.ModuleTestConfig{
		ModuleName:      "notebook",
		TestDescription: "Tests Databricks notebook module",
		RequiredVars: map[string]interface{}{
			"path":           "/Shared/" + uniqueID,
			"language":       "PYTHON",
			"content_base64": notebookContent,  // Will be base64 encoded by test
		},
		OptionalVars: map[string]interface{}{
			"format": "SOURCE",
		},
		ExpectedOutputs: []string{
			"id",
			"path",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestNotebookModuleSQLLanguage(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("notebook-sql")

	notebookContent := `-- Databricks notebook source
SELECT "Hello from SQL terratest!"
`

	config := common.ModuleTestConfig{
		ModuleName:      "notebook",
		TestDescription: "Tests Databricks notebook module with SQL language",
		RequiredVars: map[string]interface{}{
			"path":           "/Shared/" + uniqueID,
			"language":       "SQL",
			"content_base64": notebookContent,
		},
		ExpectedOutputs: []string{
			"id",
			"path",
		},
	}

	common.TestModuleWithConfig(t, config)
}

