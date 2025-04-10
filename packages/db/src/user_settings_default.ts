import * as z from "zod";

export const defaultUserSettings = {
    language: "en",
    timezone: "UTC",
    dynamicContent: false,
    externalImages: true,
    customPrompt: "",
    trustedSenders: [],
    signature: {
        enabled: false,
        content: "",
        includeByDefault: true,
    },
} satisfies UserSettings;

export const userSettingsSchema = z.object({
    language: z.string(),
    timezone: z.string(),
    dynamicContent: z.boolean(),
    externalImages: z.boolean(),
    customPrompt: z.string(),
    trustedSenders: z.string().array(),
    signature: z.object({
        enabled: z.boolean(),
        content: z.string(),
        includeByDefault: z.boolean(),
    }),
});

export type UserSettings = z.infer<typeof userSettingsSchema>