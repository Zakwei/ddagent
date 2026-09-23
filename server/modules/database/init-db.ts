// eslint-disable-next-line boundaries/dependencies -- leaf import on purpose: the collab barrel instantiates routes that read userDb, and importing it from database init would hit a TDZ cycle while the barrel is still evaluating.
import { applyCollabSchema } from "@/modules/collab/collab-migrations.js";
import { getConnection } from "@/modules/database/connection.js";
import { runMigrations } from "@/modules/database/migrations.js";
import { INIT_SCHEMA_SQL } from "@/modules/database/schema.js";

// Initialize database with schema
export const initializeDatabase = async () => {
    try {
        const db = getConnection();
        db.exec(INIT_SCHEMA_SQL);
        console.log('Database schema applied');
        runMigrations(db);
        // Collab module schema: users.role, kanban_cards.assignee_user_id,
        // card_comments, activity_events. Idempotent — a duplicate call from
        // runMigrations (wired by the coordinator) is a harmless no-op.
        applyCollabSchema(db);
    } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        console.log('Database initialization failed', { error: message });
        throw err;
    }
};
