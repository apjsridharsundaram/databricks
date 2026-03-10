package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestWorkspaceConfModule(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "workspace-conf",
		TestDescription: "Tests Databricks workspace configuration module",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"enable_results_downloading": false,
			"enable_verbose_audit_logs":  true,
		},
		ExpectedOutputs: []string{
			"workspace_conf_id",
			"applied_settings",
			"legacy_access_disabled",
			"legacy_dbfs_disabled",
		},
	}

	// Note: This may conflict with deployed config but validates module works
	common.TestModuleWithConfig(t, config)
}

func TestWorkspaceConfModuleMultipleSettings(t *testing.T) {
	config := common.ModuleTestConfig{
		ModuleName:      "workspace-conf",
		TestDescription: "Tests Databricks workspace configuration with multiple settings",
		RequiredVars:    map[string]interface{}{},
		OptionalVars: map[string]interface{}{
			"enable_export_notebook":       false,
			"enable_dbfs_file_browser":    false,
			"enable_verbose_audit_logs":   true,
		},
		ExpectedOutputs: []string{
			"workspace_conf_id",
			"applied_settings",
			"legacy_access_disabled",
			"legacy_dbfs_disabled",
		},
	}

	// Note: This may conflict with deployed config but validates module works
	common.TestModuleWithConfig(t, config)
}

