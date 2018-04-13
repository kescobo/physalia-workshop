using DataFrames
using FileIO
using CSVFiles


"""
Subsets an abundance table to columns contained in an id file. Column indicates
the header of the id file to use.
"""
function subset(tablepath::String, idpath::String, column::Symbol, outpath::String; rows=false)
    ids = load(idpath) |> DataFrame
    ids = ids[column]

    t = load(tablepath) |> DataFrame
    if rows
        keep = map(x-> in(x, ids), t[1])
        save(outpath, t[keep, :])
    else
        keep = map(x-> in(String(x), ids), names(t)[2:end])
        keep = append!([true], keep)
        save(outpath, t[keep], quotechar=nothing)
    end
end

subset("data/subsetting/mbx.csv", "data/subsetting/common_subset_samples.tsv",
    :MBX, "data/subsetting/mbx_subset.tsv")

subset("data/subsetting/mgx_pathabundances.tsv", "data/subsetting/common_subset_samples.tsv",
    :MGX, "data/subsetting/mgx_pathabundances_subset.tsv")

subset("data/subsetting/mgx_taxonomic_profiles.tsv", "data/subsetting/common_subset_samples.tsv",
    :MGX, "data/subsetting/mgx_taxonomic_profiles_subset.tsv")

subset("data/subsetting/mtx_pathabundances.tsv", "data/subsetting/common_subset_samples.tsv",
    :MGX, "data/subsetting/mtx_pathabundances_subset.tsv")

subset("data/subsetting/hmp2_metadata_subset.csv", "data/subsetting/common_subset_samples.tsv",
        :MGX, "data/subsetting/metadata_subset.csv", rows=true)
