import { getUserSettings } from "@/actions/settings";
import { useSession } from "@/lib/auth-client";
import useSWR from "swr";
import { defaultUserSettings } from "@zero/db/user_settings_default";
import { getBrowserTimezone } from "@/lib/timezones";

export function useSettings() {
  const { data: session } = useSession();

  const userId = session?.user.id;
  const { data, error, isLoading, mutate } = useSWR(
    userId ? [`user-settings`, userId] : null,
    async () => {
      try {
        const userSettings = await getUserSettings();
        // Return default settings if user has no settings saved, getting the current timezone from the browser
        if (!userSettings) {
          return {
            ...defaultUserSettings,
            timezone: getBrowserTimezone(),
          };
        }

        return userSettings;
      } catch (error) {
        console.error("Failed to load settings:", error);
        throw error;
      }
    },
  );

  return {
    settings: data,
    isLoading,
    error,
    mutate,
  };
}
