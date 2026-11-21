// src/utils/mqttHelper.js
import { LambdaClient, InvokeCommand } from "@aws-sdk/client-lambda";
import logger from "./logger.js";

// NOTE: env is read lazily (inside publishToIoT) because ESM imports are
// evaluated before dotenv.config() runs in app.js/server.js.
let lambdaClient = null;
let clientRegion = null;

function getLambdaConfig() {
  return {
    // Lambda may live in a different region than IoT Core; allow override.
    region:
      process.env.AWS_LAMBDA_REGION || process.env.AWS_REGION || "ap-south-1",
    functionName: process.env.AWS_LAMBDA_FUNCTION_NAME || "SlaveResponseToDB",
  };
}

function getLambdaClient(region) {
  if (!lambdaClient || clientRegion !== region) {
    lambdaClient = new LambdaClient({ region });
    clientRegion = region;
  }
  return lambdaClient;
}

/**
 * Publish a message to AWS IoT Core via Lambda.
 * The Lambda function does the actual IoTDataPlane publish.
 * Throws if the invocation fails OR the Lambda itself reports an error,
 * so callers don't report success for a command that never reached the device.
 */
export async function publishToIoT(topic, message) {
  const { region, functionName } = getLambdaConfig();

  logger.info(
    `🔍 Invoking Lambda "${functionName}" in ${region} for topic ${topic}`
  );

  let response;
  try {
    response = await getLambdaClient(region).send(
      new InvokeCommand({
        FunctionName: functionName,
        Payload: JSON.stringify({ mqttTopic: topic, payload: message }),
      })
    );
  } catch (error) {
    // Typical causes: missing/invalid AWS credentials in the container,
    // wrong region (ResourceNotFoundException), or missing lambda:InvokeFunction.
    logger.error(
      `❌ Lambda invocation failed (${error.name}) fn=${functionName} region=${region}: ${error.message}`
    );
    throw new Error(`Lambda invoke failed (${error.name}): ${error.message}`);
  }

  const raw = response.Payload
    ? new TextDecoder().decode(response.Payload)
    : "";

  if (response.FunctionError) {
    logger.error(
      `❌ Lambda "${functionName}" returned ${response.FunctionError}: ${raw}`
    );
    throw new Error(`Lambda error (${response.FunctionError}): ${raw}`);
  }

  // Lambda handlers often return { statusCode, body } — treat non-2xx as failure.
  let parsed = raw;
  try {
    parsed = raw ? JSON.parse(raw) : null;
  } catch {
    /* non-JSON result, keep raw string */
  }
  if (
    parsed &&
    typeof parsed === "object" &&
    typeof parsed.statusCode === "number" &&
    (parsed.statusCode < 200 || parsed.statusCode >= 300)
  ) {
    logger.error(`❌ Lambda "${functionName}" responded with failure: ${raw}`);
    throw new Error(`Lambda publish failed (status ${parsed.statusCode}): ${raw}`);
  }

  logger.info(`✅ Lambda response: ${raw}`);
  return parsed;
}

/**
 * Dummy subscribe placeholder — in AWS IoT, this is handled by IoT Rules or Lambda Triggers.
 */
export function subscribe(topic) {
  logger.info(`ℹ️ Subscriptions are handled by AWS IoT Rules. Ignored: ${topic}`);
}

/**
 * Connection initializer for logging only.
 */
export function connectMqtt() {
  logger.info("🌐 Using AWS Lambda + IAM-based IoT communication. No MQTT certs required.");
}
