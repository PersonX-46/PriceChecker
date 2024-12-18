# Preserve the jcifs classes
-keep class jcifs.** { *; }

# Preserve the org.ietf.jgss classes
-keep class org.ietf.jgss.** { *; }

# Preserve the SharedNamedPipe class references
-keep class net.sourceforge.jtds.jdbc.SharedNamedPipe { *; }

# Preserve all classes in net.sourceforge.jtds.jdbc
-keep class net.sourceforge.jtds.jdbc.** { *; }

# Suppress warnings for missing classes
-dontwarn javax.transaction.xa.XAException
-dontwarn javax.transaction.xa.Xid
-dontwarn jcifs.Config
-dontwarn jcifs.smb.NtlmPasswordAuthentication
-dontwarn jcifs.smb.SmbNamedPipe
-dontwarn org.ietf.jgss.GSSContext
-dontwarn org.ietf.jgss.GSSCredential
-dontwarn org.ietf.jgss.GSSException
-dontwarn org.ietf.jgss.GSSManager
-dontwarn org.ietf.jgss.GSSName
-dontwarn org.ietf.jgss.Oid
