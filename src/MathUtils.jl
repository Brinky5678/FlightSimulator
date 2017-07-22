#general linear interpolation function. Try to avoid this one if u know the
# number of interpolation dimensions
function lininterpnvar(x::Array,v::Array,xq::Array)


  n = length(x)
  if n == 1
    return lininterp1(x[1],v,xq[1])
  elseif n == 2
    return lininterp2(x[1],x[2],v,xq[1],xq[2])
  elseif n == 3
    return lininterp3(x[1],x[2],x[3],v,xq[1],xq[2],xq[3])
  else
    error("Linear interpolation for $n dimensions has not yet been
            implemented")
  end
end

function lininterpn(varargs...)

  n = (length(varargs) - 1)/2
  isinteger(n) ? n = Integer(n) : error("Number of arrays mismatch")

  if n == 1
    return lininterp1(varargs[1],varargs[2],varargs[3])
  elseif n == 2
    return lininterp2(varargs[1],varargs[2],varargs[3],varargs[4],varargs[5])
  elseif n == 3
    return lininterp3(varargs[1],varargs[2],varargs[3],varargs[4],varargs[5],
                varargs[6],varargs[7])
  else
    error("Linear interpolation for $n dimensions has not yet been
            implemented")
  end
end

function lininterp1(x::Array,v::Array,xq::Number)
  #a quicker function for 1D interpolation for only a single query point
  l = length(x)
  l == length(v) ? nothing : error("Dimension mismatch")
  xq = Float64(xq)

  if xq <= x[1]
    return v[1]
  elseif xq >= x[l]
    return v[l]
  else
    return lininterp1core(x,v,xq)
  end
end

function lininterp2(x::Array,y::Array,v::Array,xq::Number,yq::Number)
  l = length(x)
  m = length(y)
  ((l == size(v,1)) && (m == size(v,2))) ? nothing : error("Dimension mismatch")
  xq = Float64(xq)
  yq = Float64(yq)

  if xq <= x[1]
    if yq <= y[1]
      return v[1,1]
    elseif yq >= y[m]
      return  v[1,m]
    else
      return lininterp1core(y,v[1,:],yq)
    end
  elseif xq >= x[l]
    if yq <= y[1]
      return v[l,1]
    elseif yq >= y[m]
      return v[l,m]
    else
      return linterp1core(y,v[l,:],yq)
    end
  else
    if yq <= y[1]
      return lininterp1core(x,v[:,1],xq)
    elseif yq >= y[m]
      return lininterp1core(x,v[:,m],xq)
    else
      return lininterp2core(x,y,v,xq,yq)
    end
  end
end

function lininterp3(x::Array,y::Array,z::Array,v::Array,xq::Number,yq::Number,
                    zq::Number)

  l = length(x)
  m = length(y)
  n = length(z)
  ((l == size(v,1)) && (m == size(v,2)) && (n == size(v,3))) ? nothing :
    error("Dimension mismatch")

  xq = Float64(xq)
  yq = Float64(yq)
  zq = Float64(zq)
  if xq <= x[1]
    if yq <= y[1]
      if zq <= z[1]
        return v[1,1,1]
      elseif zq >= z[n]
        return v[1,1,n]
      else #z
        return lininterp1core(z,v[1,1,:],zq)
      end
    elseif yq >= y[m]
      if zq <= z[1]
        return v[1,m,1]
      elseif zq >= z[n]
        return v[1,m,n]
      else #z
        return lininterp1core(z,v[1,m,:],zq)
      end
    else # y
      if zq <= z[1]
        return lininterp1core(y,v[1,:,1],yq)
      elseif zq >= z[n]
        return lininterp1core(y,v[1,:,n],yq)
      else #z
        return lininterp2core(y,z,v[1,:,:],yq,zq)
      end
    end
  elseif xq >= x[l]
    if yq <= y[1]
      if zq <= z[1]
        return v[l,1,1]
      elseif zq >= z[n]
        return v[l,1,n]
      else #z
        return lininterp1(z,v[l,1,:],zq)
      end
    elseif yq >= y[m]
      if zq <= z[1]
        return v[l,m,1]
      elseif zq >= z[n]
        return v[l,m,n]
      else #z
        return lininterp1core(z,v[l,m,:],zq)
      end
    else # y
      if zq <= z[1]
        return lininterp1core(y,v[l,:,1],yq)
      elseif zq >= z[n]
        return lininterp1core(y,v[l,:,n],yq)
      else #z
        return lininterp2core(y,z,v[l,:,:],yq,zq)
      end
    end
  else #x
    if yq <= y[1]
      if zq <= z[1]
        return lininterp1core(x,v[:,1,1],xq)
      elseif zq >= z[n]
        return lininterp1core(x,v[:,1,n],xq)
      else #z
        return lininterp2core(x,z,v[:,1,:],xq,zq)
      end
    elseif yq >= y[m]
      if zq <= z[1]
        return lininterp1core(x,v[:,m,1],xq)
      elseif zq >= z[n]
        return lininterp1core(x,v[:,m,n],xq)
      else #z
        return lininterp2core(x,z,v[:,m,:],xq,zq)
      end
    else #y
      if zq <= z[1]
        return lininterp2core(x,y,v[:,:,1],xq,yq)
      elseif zq >= z[n]
        return lininterp2core(x,y,v[:,:,n],xq,yq)
      else #z
        return lininterp3core(x,y,z,v,xq,yq,zq)
      end
    end
  end
end

function lininterp1core(x::Array,v::Array,xq::Float64)
  for i=1:(length(x)-1)
    if (xq > x[i]) && (xq <= x[i+1])
      return v[i] + ((v[i+1] - v[i])/(x[i+1] - x[i]))*(xq - x[i])
    end
  end
end

function lininterp2core(x::Array,y::Array,v::Array,xq::Float64,yq::Float64)
  for i=1:length(x), j=1:length(y)
    if ((xq > x[i]) && (xq <= x[i+1])) && ((yq > y[j]) && (yq <= y[j+1]))
      return (v[i,j]*(x[i+1] - xq)*(y[j+1] - yq) +
              v[i+1,j]*(xq - x[i])*(y[j+1] - yq) +
              v[i,j+1]*(x[i+1] - xq)*(yq - y[j]) +
              v[i+1,j+1]*(xq - x[i])*(yq - y[j]))/
              ((x[i+1] - x[i])*(y[j+1] - y[j]))
    end
  end
end

function lininterp3core(x::Array,y::Array,z::Array,v::Array,xq::Float64,
                        yq::Float64,zq::Float64)
  for i=1:length(x), j=1:length(y), k=1:length(z)
    if (((xq > x[i]) && (xq <= x[i+1])) && ((yq > y[j]) && (yq <= y[j+1]))
        && ((zq > z[k]) && (zq <= z[k+1])))

      return ((v[i,j,k]*(1-(xq - x[i])/(x[i+1] - x[i])) +
              v[i+1,j,k]*(xq - x[i])/(x[i+1] - x[i]))*
              (1-(yq - y[i])/(y[i+1] - y[i])) +
              (v[i,j,k+1]*(1-(xq - x[i])/(x[i+1] - x[i])) +
              v[i+1,j,k+1]*(xq - x[i])/(x[i+1] - x[i]))*
              (yq - y[i])/(y[i+1] - y[i]))*
              (1*(zq - z[i])/(z[i+1] - z[i]))
            + ((v[i,j+1,k]*(1-(xq - x[i])/(x[i+1] - x[i])) +
              v[i+1,j+1,k]*(xq - x[i])/(x[i+1] - x[i]))*
              (1-(yq - y[i])/(y[i+1] - y[i])) +
              (v[i,j+1,k+1]*(1-(xq - x[i])/(x[i+1] - x[i])) +
              v[i+1,j+1,k+1]*(xq - x[i])/(x[i+1] - x[i]))*
              (yq - y[i])/(y[i+1] - y[i]))*
              (zq - z[i])/(z[i+1] - z[i])
    end
  end
end

"""
```julia
IsContainedInStringArray(StringArray::Array{String}, ToBeChecked::String)
```
Determines wheter ToBeChecked is contained in StringArray
"""
function IsContainedInStringArray(StringArray::Array{String},
  ToBeChecked::String)
#This function checks whether the ToBeChecked String is contained in the
#String Array
  for str in StringArray
    if ToBeChecked == str
      return true
    end
  end
  return false
end

"""
```julia
IdIntStringArray(StringArray::Vector{String}, ToBeChecked::String)
```
Outputs the index of ToBeChecked, if it is contained in StringArray, otherwise
an error is produced.
"""
function IdInStringArray(StringArray::Vector{String},ToBeChecked::String)
  for i=1:length(StringArray)
    if ToBeChecked == StringArray[i]
      return i
    end
  end
  error("String not found in String Array")
end

"""
```julia
DCM = Quat2DCM(Quat::Vector{Float64})
```
Computes the DCM corresponding the input Quaternion.
"""
function Quat2DCM(quat::Vector{Float64})

  if norm(quat) < eps()
    quat = [1., 0., 0., 0.]
  end

  q12 = quat[1]^2
  q22 = quat[2]^2
  q32 = quat[3]^2
  q42 = quat[4]^2
  q1q2 = quat[1]*quat[2]
  q3q4 = quat[3]*quat[4]
  q1q3 = quat[1]*quat[3]
  q2q4 = quat[2]*quat[4]
  q2q3 = quat[2]*quat[3]
  q1q4 = quat[1]*quat[4]

  return [[(q12 + q22 - q32 - q42) 2*(q2q3 - q1q4) 2*(q1q3 + q2q4)];
          [2*(q2q3 + q1q4) (q12 - q22 + q32 - q42) 2*(q3q4 - q1q2)];
          [2*(-q1q3 + q2q4) 2*(q1q2 + q3q4) (q12 - q22 - q32 + q42)]]
end

#create function that return 0 no matter the state input
function zerofunc(idx::Int64)
  aux = repmat([0.],idx,1)
  temp = function (varargs...)
    return aux
  end
  return temp
end


##Examples
#x = [0 pi/4 pi/2 3*pi/4 pi 5*pi/4 6*pi/4 7*pi/4 2*pi]
#y = x
#z = y
#v = sin.(x)
#v2 = repmat(sin.(x),9,1) + repmat(sin.(y)',1,9)

#vq = lininterpn(x,v,1)
#vqq = lininterp1(x,v,1)
#vq2 = lininterpn(x,y,v2,1,1)
#vqq2 = lininterp2(x,y,v2,1,1)
