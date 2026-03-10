# Design Note: Workspace Authorization Module Separation

## Overview

This document explains the architectural decision to separate workspace authorization into five distinct Terraform modules, and clarifies the conceptual differences between **role assignment**, **entitlements**, and **permissions**.

## Module Architecture

```
modules/
├── workspace-group              # WHO exists (identity layer)
├── workspace-group-member       # WHO belongs WHERE (membership layer)
├── workspace-role-assignment    # WHO can ACCESS the workspace (access layer)
├── workspace-entitlements       # WHAT capabilities they have (capability layer)
└── workspace-permissions        # WHAT they can do on WHICH objects (object layer)
```

## The Three Authorization Concepts

### 1. Workspace Role Assignment (`databricks_mws_permission_assignment`)

**Scope:** Account-level control plane
**Question answered:** "Can this principal access this workspace, and at what role?"

This is the **gateway** to the workspace. Before a group, user, or service principal can do anything in a workspace, they must be assigned to it. The two roles are:

| Role | Meaning |
|------|---------|
| `USER` | Can access the workspace as a regular user |
| `ADMIN` | Can access the workspace with full admin privileges |

**Key characteristics:**
- Operates at the Databricks **account** level (requires account-level provider)
- Uses `databricks_mws_permission_assignment` resource
- This was the **missing piece** in the original module library
- Without this assignment, a principal cannot access the workspace at all

### 2. Entitlements (`databricks_entitlements`)

**Scope:** Workspace-level capabilities
**Question answered:** "What platform capabilities does this principal have?"

Once a principal has workspace access (via role assignment), entitlements control what **platform features** they can use:

| Entitlement | Meaning |
|-------------|---------|
| `workspace_access` | Can access the workspace UI and API |
| `databricks_sql_access` | Can use Databricks SQL (warehouses, queries, dashboards) |
| `allow_cluster_create` | Can create interactive and job clusters |
| `allow_instance_pool_create` | Can create instance pools |

**Key characteristics:**
- Operates at the **workspace** level (requires workspace-level provider)
- Uses `databricks_entitlements` resource
- Controls **capability** not **object access**
- Best practice: assign entitlements to **groups**, not individual users

### 3. Permissions (`databricks_permissions`)

**Scope:** Object/resource-level access control
**Question answered:** "What can this principal do with this specific object?"

Permissions are the most **fine-grained** layer. They control access to specific workspace objects:

| Object Type | Example Permission Levels |
|-------------|--------------------------|
| Notebook | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Job | CAN_VIEW, CAN_MANAGE_RUN, IS_OWNER, CAN_MANAGE |
| Cluster | CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE |
| SQL Warehouse | CAN_USE, CAN_MANAGE, IS_OWNER |
| Directory | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |

**Key characteristics:**
- Operates at the **workspace** level (requires workspace-level provider)
- Uses `databricks_permissions` resource
- Controls access to **individual objects**
- Best practice: use **group_name** in ACL entries, not user_name

## Flow: How Authorization Works End-to-End

```
Step 1: Create groups (workspace-group)
   └── "data-engineers", "data-analysts", "workspace-admins"

Step 2: Add members to groups (workspace-group-member)
   └── user "alice@corp.com" → "data-engineers"
   └── user "bob@corp.com" → "data-analysts"

Step 3: Assign groups to workspace (workspace-role-assignment)
   └── "data-engineers" → USER role on workspace 12345
   └── "workspace-admins" → ADMIN role on workspace 12345

Step 4: Grant entitlements (workspace-entitlements)
   └── "data-engineers" → workspace_access + sql_access + cluster_create
   └── "data-analysts" → workspace_access + sql_access

Step 5: Set object permissions (workspace-permissions)
   └── /Shared directory → "data-engineers" CAN_EDIT, "data-analysts" CAN_READ
   └── SQL warehouse → "data-analysts" CAN_USE
```

## What Was Reused vs. Newly Added

| Module | Status | Origin |
|--------|--------|--------|
| `workspace-group` | Refactored | Based on existing `group` module; enhanced for bulk creation via list |
| `workspace-group-member` | Refactored | Based on existing `group-member` module; enhanced for bulk membership |
| `workspace-role-assignment` | **New** | Based on pattern from `srafromrepo/user_assignment`; redesigned for group-first RBAC |
| `workspace-entitlements` | **New** | Cleanly separated from `group` module; uses dedicated `databricks_entitlements` resource |
| `workspace-permissions` | Refactored | Based on existing `permissions` module; enhanced for multi-object assignment |

## Enterprise Best Practices

1. **Group-first RBAC:** Always prefer group-based assignment over direct user assignment
2. **Least privilege:** Start with minimal entitlements and add as needed
3. **SCIM sync:** Use `external_id` on groups to sync with your IdP
4. **Separation of concerns:** Use this module separation to enable different teams to manage different layers (e.g., platform team manages role assignments, data team manages permissions)
5. **Audit trail:** Each module produces outputs that can be used for compliance reporting
