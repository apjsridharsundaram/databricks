package test

import (
	"testing"

	common "github.com/cititerraform/common"
	"github.com/stretchr/testify/assert"
)

func TestSQLWarehouseModuleInputs(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-wh")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-warehouse",
		TestDescription: "Validates SQL warehouse module inputs",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"cluster_size": "2X-Small",
		},
		OptionalVars: map[string]interface{}{
			"max_num_clusters":          1,
			"auto_stop_mins":            10,
			"enable_photon":             true,
			"enable_serverless_compute": false,
			"warehouse_type":            "PRO",
			"spot_instance_policy":      "COST_OPTIMIZED",
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateOptionalInputs", func(t *testing.T) {
		assert.Equal(t, 1, opts.Vars["max_num_clusters"])
		assert.Equal(t, 10, opts.Vars["auto_stop_mins"])
		assert.Equal(t, true, opts.Vars["enable_photon"])
		assert.Equal(t, false, opts.Vars["enable_serverless_compute"])
		assert.Equal(t, "PRO", opts.Vars["warehouse_type"])
		assert.Equal(t, "COST_OPTIMIZED", opts.Vars["spot_instance_policy"])
		t.Log("All optional inputs validated")
	})
}

func TestSQLWarehouseModuleInputsServerless(t *testing.T) {
	uniqueID := common.GenerateUniqueTestID("sql-wh-sl")

	config := common.ModuleTestConfig{
		ModuleName:      "sql-warehouse",
		TestDescription: "Validates SQL warehouse with serverless config",
		RequiredVars: map[string]interface{}{
			"name":         uniqueID,
			"cluster_size": "2X-Small",
		},
		OptionalVars: map[string]interface{}{
			"enable_serverless_compute": true,
			"auto_stop_mins":            5,
			"max_num_clusters":          1,
		},
	}

	opts := common.GetTestTerraformOptions(t, config)

	t.Run("ValidateInputs", func(t *testing.T) {
		common.ValidateModuleInputs(t, opts, config.RequiredVars)
	})

	t.Run("ValidateServerlessConfig", func(t *testing.T) {
		assert.Equal(t, true, opts.Vars["enable_serverless_compute"])
		assert.Equal(t, 5, opts.Vars["auto_stop_mins"])
		t.Log("Serverless configuration validated")
	})
}
