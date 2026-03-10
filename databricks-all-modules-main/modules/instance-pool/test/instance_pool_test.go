package test

import (
	"testing"

	common "github.com/cititerraform/common"
)

func TestInstancePoolModule(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("pool")

	config := common.ModuleTestConfig{
		ModuleName:      "instance-pool",
		TestDescription: "Tests Databricks instance pool module",
		RequiredVars: map[string]interface{}{
			"instance_pool_name": uniqueID,
			"node_type_id":       defaults.NodeTypeID,
		},
		OptionalVars: map[string]interface{}{
			"min_idle_instances":                    0,
			"max_capacity":                          100, // High scalability support
			"idle_instance_autotermination_minutes": 10,
			"enable_elastic_disk":                   true,
			"aws_attributes": map[string]interface{}{
				"availability": "SPOT",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"instance_pool_id",
			"instance_pool_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

func TestInstancePoolModuleWithPreloadedSparkVersions(t *testing.T) {
	defaults := common.GetTestDefaults()
	uniqueID := common.GenerateUniqueTestID("pool-spark")

	config := common.ModuleTestConfig{
		ModuleName:      "instance-pool",
		TestDescription: "Tests Databricks instance pool with preloaded Spark versions",
		RequiredVars: map[string]interface{}{
			"instance_pool_name": uniqueID,
			"node_type_id":       defaults.NodeTypeID,
		},
		OptionalVars: map[string]interface{}{
			"min_idle_instances":                    0,
			"max_capacity":                          50, // High scalability with preloaded versions
			"idle_instance_autotermination_minutes": 10,
			"preloaded_spark_versions": []string{
				defaults.SparkVersion,
			},
			"aws_attributes": map[string]interface{}{
				"availability": "SPOT",
			},
		},
		ExpectedOutputs: []string{
			"id",
			"instance_pool_id",
			"instance_pool_name",
		},
	}

	common.TestModuleWithConfig(t, config)
}

