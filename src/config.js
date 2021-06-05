/**
 * Cron Config.
 *
 * If not defined, will be executed and closed.
 *
 * ```
 *  # ┌────────────── second (optional)
 *  # │ ┌──────────── minute
 *  # │ │ ┌────────── hour
 *  # │ │ │ ┌──────── day of month
 *  # │ │ │ │ ┌────── month
 *  # │ │ │ │ │ ┌──── day of week
 *  # │ │ │ │ │ │
 *  # │ │ │ │ │ │
 *  # * * * * * *
 *  ```
 *
 * @type {string | null}
 * @see https://www.npmjs.com/package/node-cron
 */
const CRON_CONFIG = process.env.CRON_CONFIG || null;

/**
 * Full file path.
 *
 * @type {string}
 */
const FILE_PATH = process.env.FILE_PATH;

/**
 * Google Drive folder ID.
 *
 * @type {string}
 */
const DRIVE_FOLDER_ID = process.env.DRIVE_FOLDER_ID;

/**
 * Retry on error times.
 *
 * @type {number}
 */
const RETRY_ON_ERROR = parseInt(process.env.RETRY_ON_ERROR) || 0;

/**
 * Google Client e-Mail.
 *
 * @type {string}
 */
const GOOGLE_CLIENT_EMAIL = process.env.GOOGLE_CLIENT_EMAIL;

/**
 * Google Private Key.
 *
 * @type {string}
 */
const GOOGLE_PRIVATE_KEY = process.env.GOOGLE_PRIVATE_KEY;

module.exports = {
  CRON_CONFIG,
  FILE_PATH,
  DRIVE_FOLDER_ID,
  RETRY_ON_ERROR,
  GOOGLE_CLIENT_EMAIL,
  GOOGLE_PRIVATE_KEY,
};
