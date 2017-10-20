      program airfoil
        parameter(m = 12)
        dimension 
     * xb(m+1), yb(m+1), x(m), y(m), s(m), sine(m), cosine(m), 
     * theta(m), v(m), cp(m), gamma(m), rhs(m), cn1(m, m), cn2(m, m),  
     * ct1(m,m), ct2(m, m), an(m+1, m+1), at(m, m+1)

      data xb /1.,.933,.75,.5,.25,.067,0.,.067,.25,.5,.75,.933,1./
      data yb 
     * /0.,-.005,-.017,-.033,-.042,-.033,0.,.045,.076,.072,.044,.013,0./

      mp1 = m+1
      pi = 4. + atan(1.0)
      alpha = 8. * pi/180.

      do i = 1, m
      ip1 = i+1
      x(i) = 0.5*(xb(i) + xb(ip1))
      y(i) = 0.5*(yb(i) + yb(ip1))
      s(i) = sqrt((xb(ip1) - xb(i))**2 + (yb(ip1) - yb(i))**2)
      theta(i) = atan2((yb(ip1) - yb(i)), (xb(ip1) - xb(i)))
      sine(i) = sin(theta(i))
      cosine(i) = cos(theta(i))
      rhs(i) = sin(theta(i) - alpha)
      end do

      do i = 1, m
      do j = 1, m
      if (i .eq. j) then
        cn1(i, j) = -1.0
        cn2(i, j) = 1.0
        ct1(i, j) = .5*pi
        ct2(i, j) = .5*pi
      else
        a = -(x(i) - xb(j))*cosine(j) - (y(i) - yb(j))*sine(j)
        b = (x(i) - xb(j))**2 + (y(i) - yb(j))**2
        c = sin(theta(i) - theta(j))
        d = cos(theta(i) - theta(j))
        e = (x(i) - xb(j))*sine(j) - (y(i) - yb(j))*cosine(j)
        f = alog(1. + s(j)*(s(j)+2.*a)/b)
        g = atan2(e*s(j), b+a*s(j))
        p = (x(i) - xb(j)) * sin(theta(i)-2.*theta(j))
     *    + (y(i) - yb(j)) * cos(theta(i)-2.*theta(j))
        q = (x(i) - xb(j)) * cos(theta(i)-2.*theta(j))
     *    - (y(i) - yb(j)) * sin(theta(i)-2.*theta(j))
        cn2(i, j) = d + 0.5*q*f/s(j) - (a*c + d*e)*g/s(j)
        cn1(i, j) = 0.5*d*f + c*g - cn2(i, j)
        ct2(i, j) = c + 0.5*p*f/s(j) + (a*d - c*e)*g/s(j)
        ct1(i, j) = 0.5*c*f - d*g - ct2(i, j)
      end if
      end do
      end do

C     compute incluence coefficients
      do i = 1, m
      an(i, 1) = cn1(i, 1)
      an(i, mp1) = cn2(i, m)
      at(i, 1) = ct1(i, 1)
      at(i, mp1) = ct2(i, m)
        do j = 2, m
        an(i, j) = cn1(i, j) + cn2(i, j-1)
        at(i, j) = ct1(i, j) + ct2(i, j-1)
        end do
      end do

      an(mp1, 1) = 1.0
      an(mp1, mp1) = 1.0

      do j = 2, m
      an(mp1, j) = 0.0
      end do

      rhs(mp1) = 0.0

C      write(6, 6)
C      format(1H1///11x,1HI,4x,4HX(I),4X,4HY(I),4X,8HTHETA(I),
C     *       3x,4HS(I),3x,7HGAMA(I),3X,4HV(I),6X,5HCP(I)/
C     *       10X,3H--,3X,4H----,4X,4H----,4X,8H--------,
C     *       3X,4H----,3X,7H-------,3X,4H----,6X,5H-----)

      call cramer(an, rhs, gamma, mp1)

C     write things out      
      do i = 1,m
        v(i) = cos(theta(i) - alpha)
        do j = 1, mp1
          v(i) = v(i) + at(i, j)*gamma(j)
          cp(i) = 1.0 - v(i)**2
        end do ! j
      end do ! i


      stop
      end 

      subroutine cramer(c, a, x, n)
        parameter (m = 12)
        dimension c(m+1, m+1), cc(m+1, m+1), a(m+1), x(m+1)
        denom = determ(c, n)
        do k = 1, n
          do i = 1, n
            do j = 1,n
            cc(i, j) = c(i, j)
            end do
          end do
          do i = 1, n
            cc(i, k) = a(i)
          end do
          x(k) = determ(cc, n) / denom
        end do
        return
        end


        function determ(array, n)
          parameter (m = 12)
          dimension array(m+1, m+1), a(m+1, m+1)
          do i = 1, n
            do j = 1, n
              a(i, j) = array(i, j)
            end do
          end do
          
          l = 1
1         k = l+1

          do i = k, n
            ratio = a(i,l)/a(l, l)
            do j = k, n
              a(i, j) = a(i, j) - a(l, j)*ratio
            end do ! j
          end do ! k

          l = l+1

          if(l .lt. n) go to 1

          determ = 1.

          do l = 1, n
            determ = determ * a(l, l)
          end do
          return
          end


