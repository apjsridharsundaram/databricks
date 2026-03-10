package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestJobModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("job")

	config := common.ModuleTestConfig{
		ModuleName:      "job",
		TestDescription: "Tests Databricks job module",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
			"tasks": []map[string]interface{}{
				{
					"task_key": "test-task",
					"notebook_task": map[string]interface{}{
						"notebook_path": "/Shared/test-notebook",
					},
					"new_cluster": map[string]interface{}{
						"spark_version": defaults.SparkVersion,
						"node_type_id":  defaults.NodeTypeID,
						"num_workers":   1,
					},
				},
			},
		},
		OptionalVars: map[string]interface{}{
			"max_concurrent_runs": 1,
			"timeout_seconds":     3600,
		},
		ExpectedOutputs: []string{
			"id",
			"job_id",
			"name",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestJobModuleWithSchedule(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("job-sched")

	config := common.ModuleTestConfig{
		ModuleName:      "job",
		TestDescription: "Tests Databricks job with schedule",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
			"tasks": []map[string]interface{}{
				{
					"task_key": "scheduled-task",
					"spark_python_task": map[string]interface{}{
						"python_file": "dbfs:/FileStore/scripts/test.py",
						"parameters":  []string{},
						"source":      "WORKSPACE",
					},
					"new_cluster": map[string]interface{}{
						"spark_version": defaults.SparkVersion,
						"node_type_id":  defaults.NodeTypeID,
						"num_workers":   1,
					},
				},
			},
		},
		OptionalVars: map[string]interface{}{
			"schedule": map[string]interface{}{
				"quartz_cron_expression": "0 0 * * * ?",
				"timezone_id":            "UTC",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"job_id",
			"name",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestJobModuleWithEmailNotifications(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("job-email")

	config := common.ModuleTestConfig{
		ModuleName:      "job",
		TestDescription: "Tests Databricks job with email notifications",
		RequiredVars: map[string]interface{}{
			"name": uniqueID,
			"tasks": []map[string]interface{}{
				{
					"task_key": "notif-task",
					"notebook_task": map[string]interface{}{
						"notebook_path": "/Shared/test-notebook",
					},
					"new_cluster": map[string]interface{}{
						"spark_version": defaults.SparkVersion,
						"node_type_id":  defaults.NodeTypeID,
						"num_workers":   1,
					},
				},
			},
		},
		OptionalVars: map[string]interface{}{
			"email_notifications": map[string]interface{}{
				"on_failure": []string{"test@example.com"},
				"on_success": []string{"test@example.com"},
			},
		},
		ExpectedOutputs: []string{
			"id",
			"job_id",
			"name",
			"url",
		},
	}

	common.TestModuleWithConfig(t, config)
}

