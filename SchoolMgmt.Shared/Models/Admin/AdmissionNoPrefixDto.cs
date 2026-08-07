using System;

namespace SchoolMgmt.Shared.Models.Admin
{
    public class AdmissionNoPrefixDto
    {
        public int PrefixId { get; set; }
        public int OrganizationId { get; set; }
        public int ClassId { get; set; }
        public string? ClassName { get; set; }
        public string Prefix { get; set; } = string.Empty;
        public int NextSequence { get; set; }
        public int PadLength { get; set; } = 2;
        public bool IsActive { get; set; } = true;
        public DateTime? CreatedOn { get; set; }
        public DateTime? ModifiedOn { get; set; }
    }

    public class AdmissionNoPrefixUpsertRequest
    {
        public int PrefixId { get; set; }
        public int ClassId { get; set; }
        public string Prefix { get; set; } = string.Empty;
        public int PadLength { get; set; } = 2;
        public bool IsActive { get; set; } = true;
    }
}
